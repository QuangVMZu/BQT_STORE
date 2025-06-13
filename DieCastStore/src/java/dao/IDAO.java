/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package dao;

import java.util.List;

/**
 *
 * @author hqthi
 */
public interface IDAO<T, K> {

    public boolean create(T entity);
    public boolean update(T entity);
    public boolean delete(K id);
    public T getById(K id);
    public List<T> getAll();

}
